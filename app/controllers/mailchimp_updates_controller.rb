class MailchimpUpdatesController < ApplicationController
  before_action :set_mailchimp_update, only: [:show, :edit, :update, :destroy]

  # GET /mailchimp_updates
  # GET /mailchimp_updates.json
  def index
    @mailchimp_updates = MailchimpUpdate.all
  end

  # GET /mailchimp_updates/1
  # GET /mailchimp_updates/1.json
  def show
  end

  # GET /mailchimp_updates/new
  def new
    @mailchimp_update = MailchimpUpdate.new
  end

  # GET /mailchimp_updates/1/edit
  def edit
  end

  # POST /mailchimp_updates
  # POST /mailchimp_updates.json
  def create
    @mailchimp_update = MailchimpUpdate.new(
      email:        params['data']['email'],
      update_type:  params['type'],
      fired_at:     params['fired_at'],
      raw_content:  params.to_json

      )

    @mailchimp_update.reason = params['data']['reason'] || nil

    respond_to do |format|
      if @mailchimp_update.save
        format.html { redirect_to @mailchimp_update, notice: 'Mailchimp update was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mailchimp_update }
      else
        format.html { render action: 'new' }
        format.json { render json: @mailchimp_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mailchimp_updates/1
  # PATCH/PUT /mailchimp_updates/1.json
  def update
    respond_to do |format|
      if @mailchimp_update.update(mailchimp_update_params)
        format.html { redirect_to @mailchimp_update, notice: 'Mailchimp update was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mailchimp_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailchimp_updates/1
  # DELETE /mailchimp_updates/1.json
  def destroy
    @mailchimp_update.destroy
    respond_to do |format|
      format.html { redirect_to mailchimp_updates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mailchimp_update
      @mailchimp_update = MailchimpUpdate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mailchimp_update_params
      params.require(:mailchimp_update).permit(:raw_content, :email, :update_type, :reason, :fired_at)
    end
end
