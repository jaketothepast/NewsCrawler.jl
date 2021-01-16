module server

using HTTP

export start_listening

function start_listening(router)
    HTTP.serve() do request::HTTP.Request
        @show request.method
        @show request
        router(request)
    end
end
end
