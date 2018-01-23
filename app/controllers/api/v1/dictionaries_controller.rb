class Api::V1::DictionariesController < ApplicationController
  def index
    @dictionaries = Dictionary.paginate(:page => params[:page], :per_page => 100)
  end

  def import
    @dictionaries = Dictionary.import(params[:import_file])
    render :index
  end
end
