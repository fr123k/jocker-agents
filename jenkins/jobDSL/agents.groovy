multibranchPipelineJob("Jocker-Agents") {
    orphanedItemStrategy {
        discardOldItems {
            numToKeep(0)
        }
    }

    description("Builds for jenkins-aws-pulumi")

    branchSources {
        // Adds a GitHub branch source.
        github {
            // Specifies a unique ID for this branch source.
            id("jenkins-aws-pulumi-branch-id")
            // Sets checkout credentials for authentication with GitHub.
            checkoutCredentialsId("deploy-key-shared-library")
            // Sets the name of the GitHub Organization or GitHub User Account.
            repoOwner("fr123k")
            // Sets the name of the GitHub repository.
            repository("jocker-agents")
            // Sets scan credentials for authentication with GitHub.
            //scanCredentialsId(String scanCredentialsId)
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('jenkins/Jenkinsfile')
        }
    }

    // trigger the repository scan once a day to delete stale jobs
    triggers {
        periodicFolderTrigger {
            interval('1d')
        }
    }
}
