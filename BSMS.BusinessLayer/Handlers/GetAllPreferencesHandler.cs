using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetAllPreferencesHandler : IRequestHandler<GetAllPreferencesQuery, IEnumerable<PreferenceDto>>
    {
        private readonly IPreferenceRepository _preferenceRepository;
        private readonly IMapper _mapper;

        public GetAllPreferencesHandler(IPreferenceRepository preferenceRepository, IMapper mapper)
        {
            _preferenceRepository = preferenceRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<PreferenceDto>> Handle(GetAllPreferencesQuery request, CancellationToken cancellationToken)
        {
            var preferences = await _preferenceRepository.GetAllAsync();

            return _mapper.Map<IEnumerable<PreferenceDto>>(preferences);
        }
    }
}
