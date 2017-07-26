class ApplicationConfigurationsController < ApplicationController

  before_action :set_configuration, only: [:edit, :update]

  def edit

    authorize @configuration
  end

  def update

    authorize @configuration

    if @configuration.update(update_params)
      flash.now[:success] = t "#{@i18n_path}.success", scope: "forms"
    else
      flash.now[:danger] = t "submission_errors", scope: "forms"
    end

    render :edit
  end

  private

  def set_configuration
    # There will only ever be one configuration record
    @configuration = ApplicationConfiguration.last
  end

  def update_params
    params.require(:application_configuration).permit(policy(@configuration).update_attributes)
  end
end
