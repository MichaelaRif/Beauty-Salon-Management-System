using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetPreferenceByIdHandler : IRequestHandler<GetPreferenceByIdQuery, PreferenceDto>
    {
        private readonly IPreferenceRepository _preferenceRepository;
        private readonly IMapper _mapper;

        public GetPreferenceByIdHandler(IPreferenceRepository preferenceRepository, IMapper mapper)
        {
            _preferenceRepository = preferenceRepository;
            _mapper = mapper;
        }

        public async Task<PreferenceDto> Handle(GetPreferenceByIdQuery request, CancellationToken cancellationToken)
        {
            var preference = await _preferenceRepository.GetByIdAsync(request.PreferenceId);

            return _mapper.Map<PreferenceDto>(preference);
        }
    }
}
