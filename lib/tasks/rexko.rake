namespace :update do
  desc "Collapse extraneous authorships (use if db older than < 0.4)"
  task :authorships => :environment do
    Source.all.each do |s|
      if s.authorship.present? 
        oas = s.authorship
        nas = Authorship.where(title_id: oas.title.try(:id), author_id: oas.author.try(:id)).order(id: :asc).first
        unless oas == nas 
          s.update_attribute(:authorship_id, nas.id)
          oas.delete if oas.sources.empty?
        end
      end
    end
  end
end