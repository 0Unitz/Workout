// RPME moved to the site root (/). This stale /rpg/ service worker unregisters
// itself and has no fetch handler, so /rpg/ falls through to the redirect page
// instead of serving a cached app copy. It deliberately does NOT delete caches:
// the 'rpme-v20' cache is shared with the root app and must survive.
self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    try { await self.registration.unregister(); } catch (e) {}
    const clients = await self.clients.matchAll({ type: 'window' });
    for (const client of clients) {
      try { client.navigate('../'); } catch (e) {}
    }
  })());
});
