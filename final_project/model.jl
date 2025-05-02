module model

using Random, Statistics

Base.@kwdef mutable struct Model
    num_patients::Int64
    gender::Vector{Bool}
    T2DM::Bool
    meanBMI::Float64
    stdBMI::Float64
    meanBW::Float64
    stdBW::Float64
    cutoffBMI::Float64
    cutoffBW::Float64
    meanSimulatedBMI::Float64
    stdSimulatedBMI::Float64
    meanSimulatedBW::Float64
    stdSimulatedBW::Float64
    BMI::Vector{Float64}
    BW::Vector{Float64}
    FFM::Vector{Float64}
    FM::Vector{Float64}
    
    function Model(num_patients::Int64, T2DM::Bool)
        self = new()
        self.num_patients = num_patients
        self.T2DM = T2DM
        self.gender = Bool[]
        self.BMI = Float64[]
        self.BW = Float64[]
        self.FFM = Float64[]
        self.FM = Float64[]

        if T2DM
            self.meanBMI = 29.7
            self.stdBMI = 4.98
            self.cutoffBMI = 20.2
            self.meanBW = 86.2
            self.stdBW = 17.2
            self.cutoffBW = 56.6
        else
            self.meanBMI = 27.1
            self.stdBMI = 4.33
            self.cutoffBMI = 18.8
            self.meanBW = 79.5
            self.stdBW = 15.6
            self.cutoffBW = 50.7
        end

        self.meanSimulatedBMI = 0.0
        self.stdSimulatedBMI = 0.0
        self.meanSimulatedBW = 0.0
        self.stdSimulatedBW = 0.0
        
        return self
    end
end

function Base.show(io::IO, model::Model)
    println(io, "Model:")
    for field in fieldnames(Model)
        value = getfield(model, field)
        if isa(value, AbstractArray)
            println(io, "  $field: $(size(value))")
        else
            println(io, "  $field: $value")
        end
    end
end

function generateBMI(model::Model)
    # Random.seed!(0)
    xtemp = model.stdBMI .* randn(model.num_patients) .+ model.meanBMI
    a = sum(xtemp .<= model.cutoffBMI)
    i = 0
    cycle = 1
    while a > 0
        xtemp[xtemp .<= model.cutoffBMI] = model.stdBMI .* randn(a, 1) .+ model.meanBMI
        a = sum(xtemp .<= model.cutoffBMI)
        print(size(a))
        cycle += 1
        i += 1
    end
    model.meanSimulatedBMI = mean(xtemp)
    model.stdSimulatedBMI = std(xtemp)
    model.BMI = xtemp
end

function generateBW(model::Model)
    #Random.seed!(0)
    male = bitrand(1000)
    model.gender = male

    maleBMI = model.BMI[male]
    femaleBMI = model.BMI[.!male]

    maleBMI_zval = (maleBMI .- mean(maleBMI)) ./ std(maleBMI)
    femaleBMI_zval = (femaleBMI .- mean(femaleBMI)) ./ std(femaleBMI)
    p_male = 0.76 # look into lit for more accurate reading
    p_female = 0.85 # look into lit for more accurate reading

    maleBW_zval = p_male .* maleBMI_zval + sqrt(1 .- p_male.^2).*randn(size(maleBMI))
    femaleBW_zval = p_female .* femaleBMI_zval + sqrt(1 .- p_female.^2).*randn(size(femaleBMI))

    BW = zeros(model.num_patients)
    BW[male] = maleBW_zval .* model.stdBW .+ model.meanBW
    BW[.!male] = femaleBW_zval .* model.stdBW .+ model.meanBW
    model.BW = BW
end

function generateFFM(model::Model)
    male = model.gender
    maleBW = model.BW[male]
    femaleBW = model.BW[.!male]

    maleBMI = model.BMI[male]
    femaleBMI = model.BMI[.!male]

    maleFFM = 9270 .* maleBW ./ (6680 .+ 216 .* maleBMI)
    femaleFFM = 9270 .* femaleBW ./ (8780 .+ 244 .* femaleBMI)
    FFM = zeros(model.num_patients)
    FFM[male] = maleFFM
    FFM[.!male] = femaleFFM
    model.FFM = FFM
    model.FM = model.BW - model.FFM
end

end
