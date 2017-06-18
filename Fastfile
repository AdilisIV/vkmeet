  #
  # Learn more here: https://github.com/fastlane/setups/blob/master/samples-ios/distribute-beta-build.md 🚀
  #
  lane :beta do |values|
    # Fabric generated this lane for deployment to Crashlytics Beta
    # set 'export_method' to 'ad-hoc' if your Crashlytics Beta distribution uses ad-hoc provisioning
    gym(scheme: 'vkmeet', export_method: 'development')

    emails = values[:test_email] ? values[:test_email] : ['fedoroff.ilia@gmail.com'] # You can list more emails here
    groups = values[:test_email] ? nil : nil # You can define groups on the web and reference them here

    crashlytics(api_token: '4442a1d938ce5871e266eedef7604224cd276b4d',
             build_secret: 'fe23f913a8f2ecfe49d66dc3bc007e9ca842cb8f0afd9e5db0dca14374d12541',
                   emails: emails,
                   groups: groups,
                    notes: 'Distributed with fastlane', # Check out the changelog_from_git_commits action
            notifications: true) # Should this distribution notify your testers via email?

    # for all available options run `fastlane action crashlytics`

    # You can notify your team in chat that a beta build has been uploaded
    # slack(
    #   slack_url: "https://hooks.slack.com/services/YOUR/TEAM/INFO"
    #   channel: "beta-releases",
    #   message: "Successfully uploaded a beta release - see it at https://fabric.io/_/beta"
    # )
  end