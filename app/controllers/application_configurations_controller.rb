class ApplicationConfigurationsController < ApplicationController

  before_action :set_configuration, only: [:edit, :update]

  def edit

    authorize @configuration
  end

  def update

    authorize @configuration

    if @configuration.update(update_params)
      flash[:success] = t "#{@i18n_path}.success", scope: "forms"
      redirect_to root_path
    else
      flash.now[:danger] = t "submission_errors", scope: "forms"
      render :edit
    end
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
