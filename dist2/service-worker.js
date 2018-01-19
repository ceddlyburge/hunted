self.addEventListener('install', function(e) {
 e.waitUntil(
   caches.open('hunted').then(function(cache) {
     return cache.addAll([
       '/',
       '/index.html',
       //'/index.html?homescreen=1',
       '/static/css/main-1e2b452d5d73305c2963.css',
       '/static/js/main-1e2b452d5d73305c2963.js',
       '/static/img/android-icon.png',
       '/static/img/touch-icon-ipad-retina-precomposed.png',
       '/static/img/touch-icon-iphone-retina-precomposed.png'
     ]);
   })
 );
});

self.addEventListener('fetch', function(event) {
    console.log('Service Worker Intercept: ' + event.request.url);

    event.respondWith(

        caches.match(event.request).then(function(response) {
        
            console.log('Service Worker Serve: ' + event.request.url);

            return response || fetch(event.request);
        
        })
        
    );
});