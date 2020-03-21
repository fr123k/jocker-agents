@Library('shared-lib')

import org.jocker.setup.SetupWizard

def call() {
    echo "${workspace}/jenkins/config/casc-config/"
    def setupWizard = new SetupWizard("${workspace}/jenkins/config/casc-config/")
                        .setup()
    return setupWizard
}

return this
