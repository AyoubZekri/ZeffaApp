{{flutter_js}}
{{flutter_build_config}}

// Zeffa web: always run the latest upload (browser tab and installed app).
//
// ZEFFA_BUILD changes with every `flutter build web`. When the site is opened
// or the installed app comes back to the screen, the bootstrap on the server
// is checked; if it has another build id, the page reloads with the new files.
// (the token is replaced by the id already in quotes, e.g. "3666618227")
const ZEFFA_BUILD = {{flutter_service_worker_version}};

// No service worker: it kept serving old versions after an upload.
// Remove the one registered by previous versions, with its caches.
try {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.getRegistrations()
      .then((regs) => regs.forEach((r) => r.unregister()))
      .catch(() => {});
  }
  if (window.caches) {
    caches.keys()
      .then((keys) => keys
        .filter((k) => k.startsWith("flutter"))
        .forEach((k) => caches.delete(k)))
      .catch(() => {});
  }
} catch (e) {}

// main.dart.js has the same name in every build: add the build id so the
// browser never reuses an old copy
_flutter.buildConfig.builds.forEach((b) => {
  if (b.mainJsPath) b.mainJsPath += "?v=" + ZEFFA_BUILD;
});

let zeffaChecking = false;
async function zeffaCheckForUpdate() {
  if (zeffaChecking) return;
  zeffaChecking = true;
  try {
    const res = await fetch("flutter_bootstrap.js?check=" + Date.now(), {
      cache: "no-store",
    });
    if (res.ok) {
      const text = await res.text();
      const m = text.match(/const ZEFFA_BUILD = "(\d+)"/);
      if (m && m[1] !== ZEFFA_BUILD) {
        location.reload();
        return;
      }
    }
  } catch (e) {
    // offline: keep the current version
  }
  zeffaChecking = false;
}

// Installed app / tab brought back to the screen
document.addEventListener("visibilitychange", () => {
  if (document.visibilityState === "visible") zeffaCheckForUpdate();
});
// Page restored from the browser's back/forward cache
window.addEventListener("pageshow", (e) => {
  if (e.persisted) zeffaCheckForUpdate();
});

_flutter.loader.load();
