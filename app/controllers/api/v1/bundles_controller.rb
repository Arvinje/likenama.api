class Api::V1::BundlesController < Api::V1::ApiController

  def index
    bundles = Bundle.active
    unless bundles.empty?
      render json: bundles, each_serializer: Api::V1::BundleSerializer, status: :ok
    else
      handle_notfound
    end
  end

end
