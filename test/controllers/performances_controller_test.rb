require "test_helper"

class PerformancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @performance = performances(:one)
  end

  test "should get index" do
    get performances_url, as: :json
    assert_response :success
  end

  test "should create performance" do
    assert_difference("Performance.count") do
      post performances_url, params: { performance: { date: @performance.date, tickets_available: @performance.tickets_available, title: @performance.title } }, as: :json
    end

    assert_response :created
  end

  test "should show performance" do
    get performance_url(@performance), as: :json
    assert_response :success
  end

  test "should update performance" do
    patch performance_url(@performance), params: { performance: { date: @performance.date, tickets_available: @performance.tickets_available, title: @performance.title } }, as: :json
    assert_response :success
  end

  test "should destroy performance" do
    assert_difference("Performance.count", -1) do
      delete performance_url(@performance), as: :json
    end

    assert_response :no_content
  end
end
