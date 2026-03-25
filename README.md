# Home Assistant Remote Access via Cloudflare Tunnel

This guide shows how to expose your Home Assistant instance securely to the internet using a Cloudflare Tunnel — without opening ports or using a VPN.

## What you get

- Access your Home Assistant from anywhere via https://example.com
- No port forwarding required
- Secure by default (Cloudflare handles TLS)

## Guide 

### 1. Create a Cloudflare Tunnel

	1.	Go to Cloudflare Zero Trust Dashboard
	2.	Navigate to Networks → Tunnels
	3.	Create a new tunnel
	4.	Choose Docker as environment (just to get the token)
	5.	Copy the generated token

### 2. Configure the public hostname

Inside the tunnel configuration:
	1.	Add a Public Hostname
	2.	Set:
    - Hostname: example.com
    - Service: http://homeassistant:8123

This tells Cloudflare to forward traffic to your Home Assistant instance inside the add-on network.

### 3. Install the Home Assistant add-on

Install this App:

- Copy the files of this repo into `/addons/home_assistant_cloudflare_tunnel`
- In the web UI, go to apps, install apps, then refresh the apps list if the Cloudflared Tunnel app doesn't show up
- Install the Cloudflared Tunnel App
- Once built, go to the app's configuration and paste the token copied in step 1.
- Start the app

If everything is correct, the add-on will connect to Cloudflare automatically.

### 4. Allow Cloudflare in Home Assistant

Home Assistant blocks reverse proxies by default. You must explicitly trust the Cloudflare tunnel.

Edit your `configuration.yaml`:

```yml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24
```

Then restart Home Assistant.

This allows requests coming from the add-on network (where cloudflared runs).

### 5. Access your instance

Open:

https://example.com (your own domain actually)

You should now see your Home Assistant login screen.

## Notes

- DNS changes may take a short time to propagate after configuring the hostname
- You do not need to expose any ports on your router
- TLS is handled automatically by Cloudflare

## Troubleshooting

### 400 Bad Request

If you see a 400 Bad Request, Home Assistant is most likely rejecting the proxy.

Fix: ensure this is set correctly in HomeAssistant `configuration.yaml`:

```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24
```

Then restart Home Assistant.

### Tunnel connects but site not reachable

- Double-check the hostname in Cloudflare
- Ensure the service is http://homeassistant:8123
- Confirm the add-on is running
