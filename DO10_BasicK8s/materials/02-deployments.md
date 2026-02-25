# Deployment strategies

Kubernetes offers a variety of deployment strategies that dictate how applications are updated within a Kubernetes cluster.

1. **Recreate** is the simplest strategy. When updating an application, this strategy deletes all current Pods first and then creates new Pods with the updated application version. This strategy can lead to temporary application downtime when all current Pods are deleted and no new Pods have been created yet.

2. The **Rolling Update** strategy is the most popular. When an application is updated, new Pods gradually replace the old ones. The number of Pods of the old and new versions of the application may vary until all Pods have been replaced by the new version.

3. **Blue/Green Deployment**: this strategy involves creating two groups of pods, called Blue and Green. Initially, traffic is directed to the Blue group while a new version of the application is deployed to the Green group. Once the Green group is ready, traffic switches to it. If a failure occurs during the switch, it is possible to quickly return to the previous version of the application.

4. **Canary Deployment**: with this strategy, the new version of the application is deployed only to a small group of users to test its functionality and performance. If all goes well, the new version is gradually deployed to all users.

5. **A/B testing**: with this strategy, different versions of the application are deployed to different groups of users to determine which version works better. This strategy is typically used to test new features or changes to the user interface.

Kubernetes manifests for each deployment strategy usually look different, but they generally have a similar structure and describe the resources needed to run and update the application.