pipelineJob("Pulumi") {
    logRotator {
        numToKeep(50)
    }

    definition {
        cps {
            script("""
node ("docker-1") {
    sh("bash --version")
    sh("make --version")
    sh("go version")
    sh("pulumi version")
    sh("pwgen")
}
            """)
        }
    }
}
