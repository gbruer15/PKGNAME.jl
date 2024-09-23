@testset "greeting" begin
    for i in 1:4
        @test greeting(i) == "Hello $i"
    end
end
