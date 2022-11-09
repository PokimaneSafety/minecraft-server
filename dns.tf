resource "cloudflare_record" "dynmap" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "dynmap"
  type    = "A"
  value   = "46.4.75.47"
  proxied = true # Take advantage of Cloudflare http caching
}

resource "cloudflare_record" "status" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "mcstatus"
  type    = "A"
  value   = "46.4.75.47"
  proxied = true # Take advantage of Cloudflare http caching
}

resource "cloudflare_record" "minecraft" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "minecraft"
  type    = "A"
  value   = "46.4.75.47"
  proxied = false # The game client needs to be able to resolve the IP address.
}
