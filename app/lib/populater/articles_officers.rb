class Populater::ArticlesOfficers
  def self.populate
    regexp_to_officer = Officer.where("hr_name IS NOT NULL").map { |o| [o.article_regexp, o] }
    Article.find_each do |article|
      officer_to_matches = {}

      # populate officer_to_matches
      regexp_to_officer.each do |regexp,officer|
        next if article_precedes_officer?(article, officer)
        matches = (article.body || "").scan(regexp)
        officer_to_matches[officer] = matches if !matches.empty?
      end

      # if two officers match on the same text, it's ambiguous, don't
      # include them
      officer_to_matches = officer_to_matches.reject do |officer, matches|
        officer_to_matches.any? do |other_officer, other_matches|
          other_officer != officer && !(matches & other_matches).empty?
        end
      end

      officer_to_matches.each do |officer, matches|
        ArticlesOfficer.create(
          officer: officer,
          article: article,
          status: :added
        )
      rescue ActiveRecord::RecordNotUnique
        # ignore
      end
    end
  end

  private

  # whether article was published before the officer started at BPD
  def self.article_precedes_officer?(article, officer)
    return false if article.date_published.blank?

    start_date = officer.doa

    if !start_date
      if officer.compensations.any? { |c| c.year <= 2014 }
        # officer left in 2015 or before
        start_date = "1980-01-01"
      else
        # officer hired after 2015
        start_date = "2015-12-15"
      end
    end

    return article.date_published < start_date
  end
end
