using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.Domain.Entities;

namespace BSMS.BusinessLayer.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<City, CityDto>()
                .ForMember(dest => dest.Country, opt => opt.MapFrom(src => src.Country.CountryName))
                .ReverseMap();


            CreateMap<Bundle, BundleDto>()
                           .ReverseMap();

            CreateMap<Country, CountryDto>().ReverseMap();

        }
    }

}
