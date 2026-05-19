/**
 * Load Firebase JS modules + default app before Flutter (iPhone Safari often
 * times out when FlutterFire injects these after the 13MB CanvasKit download).
 * Must stay on supportedFirebaseJsSdkVersion (see firebase_core_web).
 */
(function () {
  var FIREBASE_VERSION = '11.9.1';
  var isLocalDev =
    location.hostname === 'localhost' || location.hostname === '127.0.0.1';
  var devApiKey =
    typeof window.__BINISOFT_FIREBASE_API_KEY === 'string'
      ? window.__BINISOFT_FIREBASE_API_KEY.trim()
      : '';
  var firebaseConfig = {
    apiKey:
      isLocalDev && devApiKey.length > 0
        ? devApiKey
        : 'AIzaSyBkHpcfoxEZSvmFRKGwUwuO1LnmihUdGfU',
    authDomain: 'jon-sport.firebaseapp.com',
    projectId: 'jon-sport',
    storageBucket: 'jon-sport.firebasestorage.app',
    messagingSenderId: '732129842851',
    appId: '1:732129842851:web:7b0bc8e041b6e2ae645116',
  };

  async function preloadFirebase() {
    if (window.firebase_core) {
      return;
    }
    var v = FIREBASE_VERSION;
    var modules = [
      ['app', 'firebase_core'],
      ['auth', 'firebase_auth'],
      ['firestore', 'firebase_firestore'],
      ['storage', 'firebase_storage'],
    ];
    await Promise.all(
      modules.map(function (pair) {
        var name = pair[0];
        var key = pair[1];
        return import('https://www.gstatic.com/firebasejs/' + v + '/firebase-' + name + '.js').then(
          function (mod) {
            window[key] = mod;
          }
        );
      })
    );
    try {
      var core = window.firebase_core;
      var apps = core.getApps();
      // Localhost: init only when dev key present (tool/dev_run_chrome.sh writes firebase_dev_config.js).
      var mayInit =
        !apps || apps.length === 0
          ? !isLocalDev || devApiKey.length > 0
          : false;
      if (mayInit) {
        core.initializeApp(firebaseConfig);
      }
      window.__binisoft_firebase_preload = 'ok';
    } catch (e) {
      console.warn('Binisoft firebase_early:', e);
      window.__binisoft_firebase_preload = 'error:' + (e && e.message ? e.message : String(e));
    }
  }

  window.__binisoft_firebase_preload_promise = preloadFirebase().catch(function (e) {
    window.__binisoft_firebase_preload = 'error:' + (e && e.message ? e.message : String(e));
    console.warn('Binisoft firebase_early failed:', e);
  });
})();
