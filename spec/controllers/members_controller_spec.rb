require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    before(:each) do
      @campaign = FactoryBot.create(:campaign, user: @current_user)
      @member = FactoryBot.create(:member, campaign: @campaign)

      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    it "Create member related to a campaign" do
      expect(Member.last.campaign).to eql(@campaign)
    end

    it "If first member is an user" do
      expect(Member.first.campaign.user).to eql(@current_user)
      expect(Member.first.campaign.user.name).to eql(@current_user.name)
      expect(Member.first.campaign.user.email).to eql(@current_user.email)
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Own Member" do
      it "returns http success" do
        campaign = create(:campaign, user: @current_user)
        member = create(:member, campaign_id: campaign.id)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:success)
      end
    end

  end

  #describe "PUT #update" do
   # before(:each) do
    #  @new_member_attributes = attributes_for(:member)
     # request.env["HTTP_ACCEPT"] = 'application/json'
    #end

    #context "Accepted new params " do
     # before(:each) do
      #  campaign = create(:campaign, user: @current_user)
       # member = create(:member, campaign_id: campaign.id)
       # put :update, params: {id: member.id, member: @new_member_attributes}
      #end

      #it "returns http success" do
        #expect(response).to have_http_status(:success)
      #end

      #it "Member has the new attributes" do
      #  expect(Member.last.name).to eq(@new_member_attributes[:name])
      #  expect(Member.last.email).to eq(@new_member_attributes[:email])
      #  expect(Member.last.campaign.id).to eq(@new_member_attributes[:campaign_id])
      #end
    #end
  #end


end
