require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
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

    context "User is not owner the campaign and member"
      it "return http forbidden" do
        member = create(:member)
        put :destroy, params: {id: member.id}
        expect(response).to have_http_status(:forbidden)
      end
  end

  describe "PUT #update" do
    before(:each) do
      @new_member_attributes = attributes_for(:member)
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "Accepted new params and Member and Campaign user are equal  " do
      before(:each) do
        campaign = create(:campaign, user: @current_user)
        member = create(:member, campaign_id: campaign.id)
        put :update, params: {id: member.id, member: @new_member_attributes}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end


      it "Member has the new attributes" do
        expect(Member.last.name).to eq(@new_member_attributes[:name])
        expect(Member.last.email).to eq(@new_member_attributes[:email])
      end
    end

    context "Accepted new params but Member and Campaign user are not equal  " do
      before(:each) do
        member = create(:member)
        put :update, params: {id: member.id, member: @new_member_attributes}
      end

      it "return http forbidden" do
        member = create(:member)
        put :update, params: {id: member.id, member: @new_member_attributes}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


end
