local onMaster = { 'if': "${{ github.ref == 'refs/heads/master' && github.repository == 'mintel/k8s' }}" };
local notFork = { 'if': 'github.event.pull_request.head.repo.full_name == github.repository' };

local terraform = {
  job: {
    make_env:: {
      env: {
        PAGES: 'false',
      },
    },
    tf_env:: {
      'working-directory': 'tf',
      env: {
        GITHUB_TOKEN: '${{ secrets.PAT }}',
        TF_IN_AUTOMATION: '1',
      },
    },
    name: 'Create repositories',
    'runs-on': 'ubuntu-latest',
    steps: [
      { uses: 'actions/checkout@v2' },
      { uses: 'zendesk/setup-jsonnet@v7' },

      self.make_env { run: 'make tf/main.tf.json' },

      {
        uses: 'hashicorp/setup-terraform@v1',
        with: {
          cli_config_credentials_token: '${{ secrets.TF_API_TOKEN }}',
        },
      },
      self.tf_env + notFork { run: 'terraform init' },
      self.tf_env + notFork { run: 'terraform validate -no-color' },
      self.tf_env + notFork { run: 'terraform plan -no-color' },
      self.tf_env + onMaster { run: 'terraform init && terraform apply -no-color -auto-approve' },
    ],
  },
  withPages(needs): {
    name: 'Set up gh-pages branch',
    needs: needs,
    make_env:: {
      env: {
        PAGES: 'true',
      },
    },
  },
};

local libJob(name) = {
  name: 'Generate ' + name + ' Jsonnet library and docs',
  // needs: 'repos',
  'runs-on': 'ubuntu-latest',
  steps: [
    { uses: 'actions/checkout@v2' },
    {
      run: 'make build libs/' + name,
      env: {
        GIT_COMMITTER_NAME: 'minchine',
        GIT_COMMITTER_EMAIL: '73711944+minchine@users.noreply.github.com',
        SSH_KEY: '${{ secrets.DEPLOY_KEY }}',
        GEN_COMMIT: "${{ github.ref == 'refs/heads/master' && github.repository == 'mintel/k8s' }}",
        DIFF: 'true',
      },
    },
  ],
};

function(libs) {
  '.github/workflows/main.yml':
    '# Generated by `make configure`, please do not edit manually.\n'
    + std.manifestYamlDoc({
      on: {
        push: {
          branches: ['master'],
        },
        pull_request: {
          branches: ['master'],
        },
      },
      jobs: {
        [lib.name]: libJob(lib.name)
        for lib in libs
      } + {
        // repos: terraform.job,
        // repos_with_pages: terraform.job + terraform.withPages(std.sort([lib.name for lib in libs])),
        debugging: {
          name: 'Debugging Github Action values',
          'runs-on': 'ubuntu-latest',
          steps: [
            { run: 'echo onMaster? ' + onMaster['if'] },
            { run: 'echo ${{ github.repository }}' },
            { run: 'echo ${{ github.ref }}' },
            { run: 'echo ${{ github.event_name }}' },
          ],
        },
      },
    }),
}
