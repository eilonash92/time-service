# How to run the exercise

## Installation
1. Clone both service's repos -
 
```bash 
git clone git@github.com:eilonash92/time-service.git
```

```bash 
git clone git@github.com:eilonash92/facts-service.git
```

2. Install local kubernetes using Docker for Desktop.

3. Download helm installer - [https://helm.sh/docs/intro/install](https://helm.sh/docs/intro/install)

4. Install Jenkins using helm chart-

```bash
helm repo add jenkins https://charts.jenkins.io
```

```bash
helm install jenkins
```

5. Fetch your admin password -
```bash
 kubectl exec --namespace default -it svc/myjenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
```

6. Connect to your jenkins using this URL and port - [http://localhost:8080](http://localhost:8080). 

7. Install plugins - Go to Manage Jenkins -> Manage Plugins -> Choose Available tab -> Search for `docker-pipeline`, `docker`, `Steps View`

8. Go to [https://dockerhub.com](), register with username and password.

9. Add credentials to dockerhub - Go to Manage Jenkins -> Manage Credentials -> Jenkins -> Global Credentials -> New Credentials -> add the username and password and name in the id fill `docker-hub-credentials`

10. Click on "New Item" and give your pipeline the name "deploy_time_service" and choose "FreeStyle" option.

11. Under Source Code Management tab choose Git and add the time_service Github repository URL (No credentials are needed, since the repos are public)
![SCM](previews/SCM.png?raw=true "SCM")

12. Click "Save" and repeat steps 6 + 7 for facts_service.

## Usage

1. Push your new version to 'main' branch.

2. Go to Jenkins, click on the specific service' deployment job, and click "Build".

The job will run 3 stages -

a. **Build** - Building a docker image and pushing it to Dockerhub.

b. **Deploy** - Deploying the new image using helm install.

c. **Test** - Using cURL to test the web app is alive and it fails the step if the web app not returning 200 OK.

![Facts_Service](previews/Facts_Service.png?raw=true "Facts_Service")
![Time_Service](previews/Time_Service.png?raw=true "Time_Service")
![Stages](previews/Pipeline_Stages.png?raw=true "Stages")
![Main](previews/Main.png?raw=true "Main")
