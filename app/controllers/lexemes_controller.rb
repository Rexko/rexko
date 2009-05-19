class LexemesController < ApplicationController
  # GET /lexemes
  # GET /lexemes.xml
  def index
    @lexemes = Lexeme.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lexemes }
    end
  end

  # GET /lexemes/1
  # GET /lexemes/1.xml
  def show
    @lexeme = Lexeme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lexeme }
    end
  end

  def show_by_headword
    @headword = Headword.find_by_form(params[:headword])
    
    if @headword
      respond_to do |format|
        format.html { redirect_to @headword.lexeme }
        format.xml { render :xml => @headword.lexeme }
        # lexeme display in XML is currently useless, btw
      end
    else
      flash[:notice] = "There is no lexeme with <i>#{params[:headword]}</i> as headword.  You can create one below."
      respond_to do |format|
        format.html { redirect_to :action => 'new' }
        format.xml { render :nothing => true, :status => '404 Not Found' }
      end
    end
  end

  # GET /lexemes/new
  # GET /lexemes/new.xml
  def new
    @lexeme = Lexeme.new
    @new_headword = Headword.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lexeme }
    end
  end

  # GET /lexemes/1/edit
  def edit
    @lexeme = Lexeme.find(params[:id])
    @new_headword = Headword.new
  end

  # POST /lexemes
  # POST /lexemes.xml
  def create
    @lexeme = Lexeme.new(params[:lexeme])
    params[:lexeme][:dictionary_ids].each do |d_id| 
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
    
    @headword = build_if_valid(Headword, @lexeme.headwords, params[:new_headword])
    @subentry = build_if_valid(Subentry, @lexeme.subentries, params[:new_subentry])
    @phonetic_form = build_if_valid(PhoneticForm, @headword.phonetic_forms, params[:new_headword_phonetic_form]) unless @headword.nil?
    @etymology = build_if_valid(Etymology, @subentry.etymologies, params[:new_subentry_etymology]) unless @subentry.nil?
    @sense = build_if_valid(Sense, @subentry.senses, params[:new_subentry_sense]) unless @subentry.nil?
    @gloss = build_if_valid(Gloss, @sense.glosses, params[:new_subentry_sense_gloss]) unless @sense.nil?    

    respond_to do |format|
      if @lexeme.save # Is this right?
        flash[:notice] = "Lexeme was successfully created." 
        format.html do
          case params[:commit]
          when "Create and continue editing" then render :action => 'edit'
          else 
            flash[:notice] += " <a href=\"#{ url_for :controller => 'lexemes', :action => 'new' }\">Create another?</a>"
            redirect_to(@lexeme)
          end
        end
        format.xml  { render :xml => @lexeme, :status => :created, :location => @lexeme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lexeme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lexemes/1
  # PUT /lexemes/1.xml
  def update
    @lexeme = Lexeme.find(params[:id])
    @lexeme.attributes = params[:lexeme]
    params[:lexeme][:dictionary_ids].each do |d_id| 
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
    records_to_update = []

    # Update headwords.  
    @headwords = @lexeme.headwords
    @headwords.each do |headword|
      headword_param = params[:headword][headword.id.to_s]
      headword.form = headword_param[:form]
      # Update phonetic forms. Delete blank ones. Add a new one if valid.
      phonetic_forms = headword.phonetic_forms
      phonetic_forms.each do |phonetic_form|
        phonetic_form.attributes = headword_param[:phonetic_forms][phonetic_form.id.to_s]
        phonetic_forms.delete(phonetic_form) if phonetic_form.form.blank?
      end
      records_to_update << build_if_valid(PhoneticForm, phonetic_forms, params["new_phonetic_form_for_headword_#{headword.id.to_s}"])
      @headwords.delete(headword) if headword.form.blank? 
      # => add a confirmation? Check if last headword?  Fail noisily if subdata.
    end

    # Add a new headword and its phonetic form, if valid
    @new_headword = build_if_valid(Headword, @headwords, params[:new_headword])
    records_to_update << build_if_valid(PhoneticForm, @new_headword.phonetic_forms, params[:new_headword_phonetic_form]) unless @new_headword.nil?
    records_to_update << @new_headword
    # => Fail more loudly if there's a new phonetic form but no new headword.
    
    # Update subentries.
    @subentries = @lexeme.subentries
    @subentries.each do |subentry|
      subentry_param = params[:subentry][subentry.id.to_s]
      subentry.paradigm = params[:subentry][subentry.id.to_s][:paradigm]
      subentry.part_of_speech = subentry_param[:part_of_speech]
      etymologies = subentry.etymologies
      # Update etymologies.  Delete blank ones.  Add a new one if valid.
      etymologies.each do |etymology|
        etymology.attributes = subentry_param[:etymology][etymology.id.to_s]
        etymologies.delete(etymology) if [etymology.source_language, etymology.gloss, etymology.etymon].all?(&:blank?)
      end
      records_to_update << build_if_valid(Etymology, etymologies, params["new_etymology_for_subentry_#{subentry.id.to_s}"])      
      
      @subentries.delete(subentry) if subentry.paradigm.blank?
      # => add conf? check if last subentry? Fail noisily if subdata.
      
      senses = subentry.senses
      # Update senses.  Delete blank ones.  Add a new one if valid.
      senses.each do |sense|
        sense_param = subentry_param[:sense][sense.id.to_s]
        sense.definition = sense_param[:definition]
        glosses = sense.glosses
        # Update glosses.  Delete blank ones.  Add a new one if valid.
        glosses.each do |gloss|
          gloss.attributes = sense_param[:gloss][gloss.id.to_s]
          glosses.delete(gloss) if gloss.gloss.blank?
        end
        records_to_update << build_if_valid(Gloss, glosses, params["new_gloss_for_sense_#{sense.id.to_s}"])
        senses.delete(sense) if sense.definition.blank? && sense.glosses.empty?
      end
      records_to_update << build_if_valid(Sense, senses, subentry_param[:new_sense])
    end

    new_subentry = build_if_valid(Subentry, @subentries, params[:new_subentry])
    records_to_update << build_if_valid(Etymology, new_subentry.etymologies, params[:new_subentry_etymology]) unless new_subentry.nil?
    new_subentry_sense = build_if_valid(Sense, new_subentry.senses, params[:new_subentry_sense]) unless new_subentry.nil?
    records_to_update << new_subentry_sense
    records_to_update << build_if_valid(Gloss, new_subentry_sense.glosses, params[:new_subentry_sense_gloss]) unless new_subentry.nil?
    records_to_update << new_subentry

    records_to_update << @subentries.collect do |se|
      [se.etymologies, se.senses, se.senses.collect(&:glosses)]
    end
    records_to_update << @subentries
    records_to_update << @headwords.collect(&:phonetic_forms)
    records_to_update << @headwords
    records_to_update << @lexeme

    respond_to do |format|
      if records_to_update.compact.flatten.all?(&:save!)
        flash[:notice] = "Lexeme was successfully updated." 
        format.html do
          case params[:commit]
          when "Update and continue editing" then render :action => "edit"
          else 
            flash[:notice] += " <a href=\"#{ url_for :controller => 'lexemes', :action => 'new' }\">Create a new lexeme?</a>"
            redirect_to(@lexeme) 
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lexeme.errors, :status => :unprocessable_entity }
      end  
    end
  end

  # DELETE /lexemes/1
  # DELETE /lexemes/1.xml
  def destroy
    @lexeme = Lexeme.find(params[:id])
    @lexeme.destroy

    respond_to do |format|
      format.html { redirect_to(lexemes_url) }
      format.xml  { head :ok }
    end
  end

protected
  def build_if_valid klass, collection, options = {}
    new_record = klass.new(options)
    if new_record.valid?
      new_record.save  # Furf?
      collection << new_record 
      return new_record
    else
      return nil
    end
  end
end
