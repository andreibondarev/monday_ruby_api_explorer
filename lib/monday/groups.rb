class Monday::Groups < Monday::HttpRequest
  def list(board_id)
    request = {
      'query': "query {
        boards (ids: #{board_id}) {
          id
          name
          groups {
            archived
            color
            deleted
            id
            position
            title
          }
        }
      }"
    }

    response = request(request, :post)
    response.dig('data', 'boards').first
  end
end