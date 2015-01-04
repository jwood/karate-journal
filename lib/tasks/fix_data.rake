desc "Fix data"
task :fix_data => :environment do
  corrections = {
    "â€™" => "'",
    "â€“" => "-",
    "â€¦" => "...",
    "â€œ" => '"',
    "â€" => '"'
  }

  Entry.find_each do |entry|
    corrections.each do |symbol, replacement|
      entry.body = entry.body.gsub(symbol, replacement)
    end
    entry.save
  end
end
