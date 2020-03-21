node('master') {
    stage('Checkout') {
        cleanWs()
        checkout scm
    }

    stage('Agents') {
        // run SetupWizard from fr123k/jenkins-shared-library
        def setup = load('jenkins/config/groovy/setup.groovy')
        setup()
            //the pipeline script in the jobDSL/pulumi.groovy
            .getScriptApproval().approveScript('6d2ccc5267db0f3b500aa96a1ec53264613a1209')
    }

    stage('Seed') {
        // https://issues.jenkins-ci.org/browse/JENKINS-44142
        // --> Note: when using multiple Job DSL build steps in a single job, set this to "Delete" only for the last Job DSL build step. 
        // Otherwise views may be deleted and re-created. See JENKINS-44142 for details.
        jobDsl(targets: 'jenkins/jobDSL/folders.groovy', sandbox: false, removedJobAction: 'IGNORE')
        jobDsl(targets: 'jenkins/jobDSL/*.groovy', sandbox: false, removedJobAction: 'DELETE')
    }
}
