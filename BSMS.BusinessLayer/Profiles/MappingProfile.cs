using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.Domain.Entities;
using MediatR;

namespace BSMS.BusinessLayer.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<City, CityDto>()
                           .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.CityName))
                           .ForMember(dest => dest.CountryName, opt => opt.MapFrom(src => src.Country != null ? src.Country.CountryName : null));

            CreateMap<Bundle, BundleDto>()
                           .ReverseMap();

        }
    }

}
