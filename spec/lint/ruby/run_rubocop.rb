RSpec.describe 'Check to see if the files that have changed have correct syntax' do
  before do
    current_sha = 'origin/master..HEAD'
    options = '--no-commit-id --diff-filter=ACMRT --name-only'
    grep = 'grep .rb | grep -e rblx'
    @files =
      `git diff-tree #{options} -r #{current_sha} | #{grep}`
    @files.tr!("\n", ' ')
  end

  it 'runs rubocop on changed ruby files' do
    if @files.empty?
      puts 'Linting not performed. No ruby files changed.'
    else
      puts "Running rubocop for changed files: #{@files}"
      result = system \
        "bundle exec rubocop --config spec/lint/ruby/.rubocop.yml #{@files}"
      expect(result).to be(true)
    end
  end
end
