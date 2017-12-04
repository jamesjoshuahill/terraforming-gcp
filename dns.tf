resource "google_dns_managed_zone" "env_dns_zone" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.env_name}.${var.dns_suffix}."
  description = "DNS zone for the ${var.env_name} environment"
}

resource "google_dns_record_set" "ops-manager-dns" {
  name = "pcf.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_instance.ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"]
}

resource "google_dns_record_set" "optional-ops-manager-dns" {
  name  = "pcf-optional.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type  = "A"
  ttl   = 300
  count = "${min(length(split("", var.optional_opsman_image_url)),1)}"

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_instance.optional-ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"]
}
