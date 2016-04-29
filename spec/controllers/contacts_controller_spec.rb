require 'rails_helper'

describe ContactsController do

    describe 'GET #index' do
        context 'with params[:letter]' do
            it "populates an array of contacts starting with the letter"
            it "renders the :index template"
        end

        context 'without params[:letter]' do
            it "populates an array of all contacts"
            it "renders the :index template"
        end
    end

    describe 'GET #show' do
        it "assigns the requested contact to @contact"
        it "renders the :show template"
    end

    describe 'GET #new' do
        it "assigns a new Contact to @contact"
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested contact to @contact"
        it "renders the :edit template"
    end

    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new contact in the database"
            it "redirects to contacts#show"
        end

        context "with invalid attributes" do
            it "does not save the new contact in the database"
            it "re-renders the :new template"
        end
    end

    describe 'PATCH #update' do
        context "with valid attributes" do
            it "updates the contact in the database"
            it "redirects to the contact"
        end

        context "with invalid attributes" do
            it "does not update the contact"
            it "re-renders the :edit template"
        end
    end

    describe 'DELETE #destroy' do
        it "deletes the contact from the database"
        it "redirects to users#index"
    end

end
