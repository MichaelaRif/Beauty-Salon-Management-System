using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetCityByIdHandler : IRequestHandler<GetCityByIdQuery, CityDto>
    {
        private readonly ICityRepository _cityRepository;
        private readonly IMapper _mapper;

        public GetCityByIdHandler(ICityRepository cityRepository, IMapper mapper)
        {
            _cityRepository = cityRepository;
            _mapper = mapper;
        }

        public async Task<CityDto> Handle(GetCityByIdQuery request, CancellationToken cancellationToken)
        {
            var city = await _cityRepository.GetByIdAsync(request.CityId);

            return _mapper.Map<CityDto>(city);
        }
    }
}
