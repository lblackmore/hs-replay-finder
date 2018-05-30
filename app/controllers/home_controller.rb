class HomeController < ApplicationController

  def index
    @legend_stats = ReplayStatsCache.new.legend_stats
    @replay_data = JsonResponseCache.new(params).cached_json_response || "{}"
  end
end
