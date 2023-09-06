'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/fonts/MaterialIcons-Regular.otf": "32fce58e2acb9c420eab0fe7b828b761",
"assets/images/30avatar.png": "a557a9f60e9ed568e6b6d06588590413",
"assets/images/10avatar.png": "5240d36ecdf1688905b9e54a512a6bbe",
"assets/images/13avatar.png": "0fa2041667cc29bfec9ffbb945f39aee",
"assets/images/27avatar.png": "55271245ea15bb40d5a7061277d75780",
"assets/images/9avatar.png": "a341fb8629621a46180482a9164e4818",
"assets/images/17avatar.png": "b13db50ca89fc68e5d2dc6c815c5616f",
"assets/images/5avatar.png": "868bed1806832b807c5ad82b7f56eb02",
"assets/images/22avatar.png": "e8c2d7fd47ebc773dcc4f3c7aefb4ba5",
"assets/images/2avatar.png": "82bcfc34088392b8101a38cc95a4ad10",
"assets/images/24avatar.png": "ecf4da055abc3add8d353781e6ed0cb3",
"assets/images/20avatar.png": "fbe10ad8517ff296225c4d1d3a235b8a",
"assets/images/8avatar.png": "bbdf99427c95b9ac69fe5e61de0d5c72",
"assets/images/26avatar.png": "e9a2317094a457c21d7726a01f9e2936",
"assets/images/14avatar.png": "c33e9a0eba0ab55a77787d6f4d298163",
"assets/images/28avatar.png": "73559e0d6a2334e436234144458a5f03",
"assets/images/16avatar.png": "63062b4de0c104da01f59c7008820aa4",
"assets/images/7avatar.png": "1866c6df807b259068b3e10cc3c0b7f1",
"assets/images/19avatar.png": "39c069243ffba2cce7b29b2bc00704c6",
"assets/images/23avatar.png": "3bd000a418d4331e910e65a9584b5c0f",
"assets/images/25avatar.png": "91628b242db2e344a8b7862d54311a7b",
"assets/images/3avatar.png": "65dd1a73eea53e3c79787bb1562f0b77",
"assets/images/1avatar.png": "39f7d73b99ffdf8f3e7ace33340e018c",
"assets/images/6avatar.png": "a0bd23d0ad0eecea1558518f8e2bc4c8",
"assets/images/29avatar.png": "11b84c889cccbbea8c92291e0df5b619",
"assets/images/4avatar.png": "1fa4bcbe9f9f414076782270495c2724",
"assets/images/18avatar.png": "f25dee19c28d7ac5f1a3fea3c0f208b8",
"assets/images/21avatar.png": "8cef286a005482d4543cb451fcffda9c",
"assets/images/12avatar.png": "a9e42ccdd20b10ff27aa7bbcacd7a5a6",
"assets/images/15avatar.png": "ee6f173518ccbfd9af6ef017c0e1924f",
"assets/images/11avatar.png": "27a8d121e451f71cfcef7a8950dde8a2",
"assets/AssetManifest.json": "6aa638fcf78ff0e3a24858d7d13871bd",
"assets/packages/app_ui/assets/fonts/OpenSans-SemiBold.ttf": "58fb53a79ecf1314a1f38bceb8b2a992",
"assets/packages/app_ui/assets/fonts/OpenSans-Medium.ttf": "3df8f041f884b3fd7e14c8fd4c3d9a1d",
"assets/packages/app_ui/assets/fonts/OpenSans-Regular.ttf": "7df68ccfcb8ffe00669871052a4929c9",
"assets/packages/app_ui/assets/fonts/OpenSans-Bold.ttf": "5112859ee40a5dfa527b3b4068ccd74d",
"assets/packages/app_ui/assets/images/30avatar.png": "a557a9f60e9ed568e6b6d06588590413",
"assets/packages/app_ui/assets/images/10avatar.png": "5240d36ecdf1688905b9e54a512a6bbe",
"assets/packages/app_ui/assets/images/13avatar.png": "0fa2041667cc29bfec9ffbb945f39aee",
"assets/packages/app_ui/assets/images/27avatar.png": "55271245ea15bb40d5a7061277d75780",
"assets/packages/app_ui/assets/images/9avatar.png": "a341fb8629621a46180482a9164e4818",
"assets/packages/app_ui/assets/images/17avatar.png": "b13db50ca89fc68e5d2dc6c815c5616f",
"assets/packages/app_ui/assets/images/5avatar.png": "868bed1806832b807c5ad82b7f56eb02",
"assets/packages/app_ui/assets/images/22avatar.png": "e8c2d7fd47ebc773dcc4f3c7aefb4ba5",
"assets/packages/app_ui/assets/images/2avatar.png": "82bcfc34088392b8101a38cc95a4ad10",
"assets/packages/app_ui/assets/images/24avatar.png": "ecf4da055abc3add8d353781e6ed0cb3",
"assets/packages/app_ui/assets/images/20avatar.png": "fbe10ad8517ff296225c4d1d3a235b8a",
"assets/packages/app_ui/assets/images/8avatar.png": "bbdf99427c95b9ac69fe5e61de0d5c72",
"assets/packages/app_ui/assets/images/26avatar.png": "e9a2317094a457c21d7726a01f9e2936",
"assets/packages/app_ui/assets/images/14avatar.png": "c33e9a0eba0ab55a77787d6f4d298163",
"assets/packages/app_ui/assets/images/ic_pencil.svg": "01f81d2b35e4e3c384324b8c0c2fa5e4",
"assets/packages/app_ui/assets/images/28avatar.png": "73559e0d6a2334e436234144458a5f03",
"assets/packages/app_ui/assets/images/16avatar.png": "63062b4de0c104da01f59c7008820aa4",
"assets/packages/app_ui/assets/images/7avatar.png": "1866c6df807b259068b3e10cc3c0b7f1",
"assets/packages/app_ui/assets/images/19avatar.png": "39c069243ffba2cce7b29b2bc00704c6",
"assets/packages/app_ui/assets/images/23avatar.png": "3bd000a418d4331e910e65a9584b5c0f",
"assets/packages/app_ui/assets/images/25avatar.png": "91628b242db2e344a8b7862d54311a7b",
"assets/packages/app_ui/assets/images/3avatar.png": "65dd1a73eea53e3c79787bb1562f0b77",
"assets/packages/app_ui/assets/images/1avatar.png": "39f7d73b99ffdf8f3e7ace33340e018c",
"assets/packages/app_ui/assets/images/6avatar.png": "a0bd23d0ad0eecea1558518f8e2bc4c8",
"assets/packages/app_ui/assets/images/29avatar.png": "11b84c889cccbbea8c92291e0df5b619",
"assets/packages/app_ui/assets/images/4avatar.png": "1fa4bcbe9f9f414076782270495c2724",
"assets/packages/app_ui/assets/images/18avatar.png": "f25dee19c28d7ac5f1a3fea3c0f208b8",
"assets/packages/app_ui/assets/images/21avatar.png": "8cef286a005482d4543cb451fcffda9c",
"assets/packages/app_ui/assets/images/12avatar.png": "a9e42ccdd20b10ff27aa7bbcacd7a5a6",
"assets/packages/app_ui/assets/images/15avatar.png": "ee6f173518ccbfd9af6ef017c0e1924f",
"assets/packages/app_ui/assets/images/11avatar.png": "27a8d121e451f71cfcef7a8950dde8a2",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "de8c1126e38d69700695b4ebbd263379",
"assets/FontManifest.json": "71cc62f025d5b51eec00696fedff94ee",
"assets/NOTICES": "ea871b6352b50ae6232575c2ff4c195f",
"version.json": "bd5ed66b87e6be1e73cee0d865a686a9",
"manifest.json": "438cd2303ebc718ebac05bbcdf5a6136",
"index.html": "a2e3bb4aa488264bc7faad8390adcf89",
"/": "a2e3bb4aa488264bc7faad8390adcf89",
"favicon.png": "7a26ea9d4e61122fc023b84e5acdb148",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"icons/Icon-192.png": "12d05db1c0b26d429b54e3f8c946a496",
"icons/favicon.png": "7a26ea9d4e61122fc023b84e5acdb148",
"icons/Icon-512.png": "aabba36693aba0ec8d954adf297d3125",
"main.dart.js": "2163f990f8f7ff292ca986b84af812ac",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
