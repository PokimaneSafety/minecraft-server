resource "cloudflare_record" "dynmap" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = "dynmap"
  value   = "3.231.247.106"
  type    = "A"
  proxied = true
}
