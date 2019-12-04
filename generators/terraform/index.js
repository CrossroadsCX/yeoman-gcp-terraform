const Generator = require('yeoman-generator')

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts)

    this.tf_admin = process.env.TF_ADMIN || null
  }

  async initializing() {
    console.log(this.tf_admin)
  }

  async prompting() {
    if (!this.tf_admin) {
      this.answers = this.prompt([
        {
          type: 'input',
          name: 'tf_admin',
          message: 'No TF_ADMIN env variable is set. Please enter TF_ADMIN:'
        }
      ])
    }
  }

  async configuring() {
    if (!this.tf_admin) {
      throw new Error('No TF_ADMIN set, aborting')
    }
  }

  async writing() {
    const { tf_admin } = this.answers

    await this.fs.copyTpl(
      this.templatePath('backend.tf'),
      this.destinationPath('backend.tf'), {
        tf_admin,
      },
    )

    await this.fs.copy(
      this.templatePath('project.tf'),
      this.destinationPath('project.tf')
    )
  }
}
