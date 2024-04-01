setup-k3s: # sets up a k3s cluster
	@read -p "cluster name: " name; \
	k3d cluster create $$name --image docker.io/rancher/k3s:v1.26.11-k3s2; \
	plural cd clusters bootstrap --name $$name

login: # logs in w/ plural cli
	@read -p "Console url: " url;
	@read -p "Console access token: " token;
	@plural cd login --url $$url --token $$token
