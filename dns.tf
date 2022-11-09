resource "cloudflare_record" "dynmap" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "dynmap"
  type    = "A"
  value   = "3.231.247.106"
  proxied = true # Take advantage of Cloudflare http caching
}

resource "cloudflare_record" "minecraft" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "minecraft"
  type    = "A"
  value   = "3.231.247.106"
  proxied = false # The game client needs to be able to resolve the IP address.
}
