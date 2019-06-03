RSpec.describe 'Check to see if the files that have changed will pass foodcritic.' do
  before do
    @include_rules = %w[
      FC007
      FC052
      FC053
      FC063
    ]

    # Foodcritic rules to exclude.
    @exclude_rules = %w[
      FC014
      FC015
      FC024
      FC064
      FC065
      FC071
      FC078
      FC093
    ]

    @exclude_rules = @exclude_rules.join(' -t ~')
    @include_rules = @include_rules.join(' -t ')

    # Diff-tree of only files in cookbooks
    current_sha = 'origin/master..HEAD'
    options = '--no-commit-id --diff-filter=ACMRT --name-only'
    grep_roblox = 'grep cookbooks | grep -e rblx'
    grep_others = 'grep cookbooks | grep -v -e rblx'
    @roblox_files =
      `git diff-tree #{options} -r #{current_sha} | #{grep_roblox}`
    @other_files =
      `git diff-tree #{options} -r #{current_sha} | #{grep_others}`

    @roblox_files = @roblox_files.split("\n")
    @other_files = @other_files.split("\n")

    @roblox_cookbooks = []
    @roblox_files.each do |file|
      dir = 'cookbooks/' + file.split('/')[1]
      @roblox_cookbooks << dir
    end
    @roblox_cookbooks = @roblox_cookbooks.uniq.join(' ')

    @other_cookbooks = []
    @other_files.each do |file|
      dir = 'cookbooks/' + file.split('/')[1]
      @other_cookbooks << dir
    end
    @other_cookbooks = @other_cookbooks.uniq.join(' ')
  end

  it 'runs foodcritic on changed roblox cookbook files' do
    if @roblox_cookbooks.empty?
      puts 'Foodcritic not performed. No roblox cookbooks files changed.'
    else
      puts 'Running foodcritic for changed roblox cookbooks: ' +
             "#{@roblox_cookbooks}"
      puts 'bundle exec foodcritic -f any -t ' +
             "~#{@exclude_rules} #{@roblox_cookbooks}"
      args = 'bundle exec foodcritic -f any -t ' +
        "~#{@exclude_rules} #{@roblox_cookbooks}"
      result = system args
      expect(result).to be(true)
    end
  end

  it 'runs foodcritic on changed open source cookbook files' do
    if @other_cookbooks.empty?
      puts 'Foodcritic not performed. No open source cookbooks files changed.'
    else
      puts 'Running foodcritic for changed open source cookbooks: ' +
             "#{@other_cookbooks}"
      puts 'bundle exec foodcritic -f any -t ' +
             "#{@include_rules} #{@other_cookbooks}"
      args = 'bundle exec foodcritic -f any -t ' +
        "#{@include_rules} #{@other_cookbooks}"
      result = system args
      expect(result).to be(true)
    end
  end
end
