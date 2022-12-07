class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]
    #skip_before_action :verify_authenticity_token
    def index
        @locations = Location.all
    end

    def show
    end

    def new
        @location = Location.new
    end

    def create
        if Location.find_by(location_id: params[:location_id])
            return;
        end
        @location = Location.new(location_params)
        Location.update_all(:is_selected => false)

        if @location.save
            respond_to do |format|
                format.turbo_stream
            end
        else
            render :new, status: :unprocessable_entity
        end
        @location.create_daily_data
    end

    def edit
    end

    def update
        if @location.update(location_params)
            redirect_to locations_path, notice: "location was successfully updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @location.destroy

        if Location.all.count > 0
            Location.all.first.update!(:is_selected => true)
        end
        respond_to do |format|
            #format.html { redirect_to location_path, notice: "location was successfully destroyed." }
            format.turbo_stream
        end
    end

    private

    def set_location
        @location = Location.find(params[:id])
    end

    def location_params
        params.require(:location).permit(:name, :lat, :lng, :timezone, :location_id)
    end
end
