'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"index.html": "abfba01c587c7ee3dd40c9c70f8f70c3",
"/": "abfba01c587c7ee3dd40c9c70f8f70c3",
"assets/NOTICES": "7f088f9ce5d0bb22ca6a0568d4054f82",
"assets/assets/profile/elo.png": "97e49406d40ab9b3a93951d7aa58b342",
"assets/assets/profile/funa.png": "d1d71f2b42424756ff191fef663804da",
"assets/assets/profile/timto.png": "3496a182c0dbb43a8c4c2713b0876b5c",
"assets/assets/profile/zam.png": "08023458ee3eedc4056c96cb9649fdc4",
"assets/assets/images/vaatigames.png": "fa03da79d635ffac508f26a459042777",
"assets/assets/images/1.png": "88fab94ca0f6e15e8c11509ddbbc696e",
"assets/assets/images/booster.png": "e94b03ea4e42bccaff82f3639d8d9c16",
"assets/assets/images/5.png": "d0379b50f138685e3141248420cd19a5",
"assets/assets/images/logo.png": "cf6eea305ba6187a71a08b969ffcabd4",
"assets/assets/images/0.png": "58774fc5a38654fe3c3801144585407d",
"assets/assets/images/3.png": "d23e7e75a434ed01b9e4c10eb4c83ffb",
"assets/assets/images/4.png": "073c8e657dc70e2d4711b68e1506d2ff",
"assets/assets/images/2.png": "cfd8c08430fb2f8c2304da8b05454697",
"assets/assets/icones/Dragon.png": "69f4a1fa787bffe976a52a08937e3e2a",
"assets/assets/icones/Plante.png": "7da175d2f52d0794a1a8775363e0ad04",
"assets/assets/icones/M%25C3%25A9tal.png": "dd33f3cbf439398cfa36c67731030272",
"assets/assets/icones/Ice.png": "5165971025dfb0d3dd470007507534a0",
"assets/assets/icones/Poison.png": "2dd3c3150b7b017935ca13b946f758c6",
"assets/assets/icones/Grass.png": "468620f49b76b49513b2c897b058adda",
"assets/assets/icones/%25C3%2589lectrique.png": "6976d6b845c593743e6590eae5961314",
"assets/assets/icones/Neutre.png": "6bb928a38f950484df3a4968d39dc334",
"assets/assets/icones/T%25C3%25A9n%25C3%25A8bres.png": "ef9a42ae159ed55d591ad21a40e2968c",
"assets/assets/icones/Flying.png": "b022c23fa46b93d73190bbf5a29cfbcd",
"assets/assets/icones/Psy.png": "99e03a110a392d0cdc9633797e1a75e3",
"assets/assets/icones/Rock.png": "88118b251cc86b0de1920eb5bb3d2360",
"assets/assets/icones/Fairy.png": "cbff5209e20a9b898e35245d14f3eae4",
"assets/assets/icones/Ghost.png": "83320df64bfe257f50dc220509b124de",
"assets/assets/icones/Feu.png": "f71ca366cf0c9bc5e2fad76c803d8ef8",
"assets/assets/icones/Eau.png": "fd79cb8eccad87c014f0f5e261dccd41",
"assets/assets/icones/Ground.png": "e252a3748ad80143abc3342c7807e48b",
"assets/assets/icones/Combat.png": "011c914bc8e2fee4d91c7f9a5986e085",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "10ab6ebb302fa49fff24cc35a89b38da",
"assets/fonts/Outfit-Light.ttf": "905f109c79bd9683fc22eaffe4808ffe",
"assets/fonts/Outfit-ExtraLight.ttf": "f257db4579a91feb1c1f0e80daae48ae",
"assets/fonts/Outfit-ExtraBold.ttf": "d649fd9b3a7e7c6d809b53eede996d18",
"assets/fonts/Outfit-Medium.ttf": "3c88ad79f2a55beb1ffa8f68d03321e3",
"assets/fonts/Outfit-Black.ttf": "d032ccd62028487a6c8d70a07bda684b",
"assets/fonts/Outfit-Bold.ttf": "e28d1b405645dfd47f4ccbd97507413c",
"assets/fonts/Outfit-Thin.ttf": "8f281fc8ba39d6f355190c14b6532b44",
"assets/fonts/Outfit-SemiBold.ttf": "f4bde7633a5db986d322f4a10c97c0de",
"assets/fonts/Outfit-Regular.ttf": "9f444021dd670d995f9341982c396a1d",
"assets/fonts/MaterialIcons-Regular.otf": "b7fdc29b1e78e62adc05f8f0c2ebde45",
"assets/FontManifest.json": "c350b7328a84353e2334468b668f7eef",
"assets/AssetManifest.bin.json": "4f3b9869162b6833edf452394f9995e4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.json": "1bb23f200a095e731268da166cbd0fff",
"version.json": "64f56803266eb3dacee16fad8df6e112",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "a642a406786140d974c48049078f9805",
"CNAME": "a6513b469483574214643f042b028f74",
"robots.txt": "9152d7f1724ed8fbcd2e0c87029f193c",
"icons/Icon-maskable-512.png": "6477e8d51f0819cc2f030d96d522a14b",
"icons/Icon-192.png": "175c366c29b59873d607142db510d90a",
"icons/Icon-512.png": "6477e8d51f0819cc2f030d96d522a14b",
"icons/Icon-maskable-192.png": "175c366c29b59873d607142db510d90a",
"manifest.json": "222d024ccbc8f58d5269927a18fb4152",
"favicon.png": "25a902abe71d6394aad5e1253d3cbb85",
"flutter_bootstrap.js": "4d9f68b90d2fd53474aaef25b8b90927"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
