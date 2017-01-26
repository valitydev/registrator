#!groovy

build('registrator', 'docker-host') {
  checkoutRepo()

  runStage('build') {
    env.IMG_TAG = sh(script: "cat VERSION", returnStdout: true).trim()
    sh "make build"
  }

  try {
    if (env.BRANCH_NAME == 'master') {
      runStage('push image') {
        getCommitId()
        sh 'docker tag registrator:$IMG_TAG dr.rbkmoney.com/registrator:$COMMIT_ID'

        try {
          docker.withRegistry('https://dr.rbkmoney.com/v2/', 'dockerhub-rbkmoneycibot') {
            sh 'docker push dr.rbkmoney.com/registrator:$COMMIT_ID'
          }
        } finally {
          sh 'docker rmi -f dr.rbkmoney.com/registrator:$COMMIT_ID'
        }
      }
    }
  } finally {
    runStage('rm local image') {
      sh 'docker rmi -f registrator:$IMG_TAG'
    }
  }
}
