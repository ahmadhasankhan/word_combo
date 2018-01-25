class Api::V1::DictionariesController < ApplicationController
  def import
    @dictionaries = Dictionary.import(params[:import_file])
    render :index
  end
end
