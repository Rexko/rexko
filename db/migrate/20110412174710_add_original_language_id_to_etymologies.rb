class AddOriginalLanguageIdToEtymologies < ActiveRecord::Migration[4.2]
  def self.up
    add_column :etymologies, :original_language_id, :integer

    say_with_time 'Associating Languages with Etymologies...' do
      etyma = Etymology.all.select(:source_language)

      etyma.collect(&:source_language).uniq.each do |langname|
        lang = if ['Latin', '', 'Kirumb'].include? langname
                 case langname
                 when 'Latin'
                   Language.find_or_create_by_iso_639_code('la')
                 when 'Kirumb'
                   Language.find_or_create_by_iso_639_code('art-kirumb')
                 when ''
                   nil
                 end
               else
                 Language.find_or_create_by_default_name(langname)
               end

        Etymology.update_all(['original_language_id = ?', lang.try(:id)], ['source_language = ?', langname])
      end
    end

    remove_column :etymologies, :source_language
  end

  def self.down
    add_column :etymologies, :source_language

    say_with_time 'Restoring language names to etymologies...' do
      Language.find_each do |lang|
        Etymology.update_all(['source_language = ?', lang.name], ['original_language_id = ?', lang.id])
      end
    end

    remove_column :etymologies, :original_language_id
  end
end
