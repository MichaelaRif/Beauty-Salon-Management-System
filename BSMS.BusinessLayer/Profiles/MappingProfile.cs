using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Services;
using BSMS.Domain.Entities;

namespace BSMS.BusinessLayer.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<City, CityDto>()
                .ReverseMap();

            CreateMap<Bundle, BundleDto>()
                .ReverseMap();

            CreateMap<Country, CountryDto>()
                .ReverseMap();

            CreateMap<Address, AddressDto>()
                .ReverseMap();

            CreateMap<Customer, CustomerDto>()
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.CustomerPronoun.Pronoun1))
                .ReverseMap();

            CreateMap<Customer, UserInfo>()
                .ForMember(dest => dest.Sub, opt => opt.MapFrom(src => src.CustomerKeycloakId))
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.CustomerPronoun.Pronoun1))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.CustomerDob))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.CustomerPn))
                .ForMember(dest => dest.GivenName, opt => opt.MapFrom(src => src.CustomerFn))
                .ForMember(dest => dest.FamilyName, opt => opt.MapFrom(src => src.CustomerLn))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.CustomerEmail))
                .ReverseMap();

            CreateMap<CustomerDto, UserInfo>()
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.PronounName))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.CustomerDob))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.CustomerPn))
                .ForMember(dest => dest.GivenName, opt => opt.MapFrom(src => src.CustomerFn))
                .ForMember(dest => dest.FamilyName, opt => opt.MapFrom(src => src.CustomerLn))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.CustomerEmail))
                .ReverseMap();

            CreateMap<Address, UserInfo>()
                .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.AddressCity.CityName))
                .ReverseMap();

            CreateMap<UserInfo,AddressDto>()
                .ForMember(dest => dest.AddressCity, opt => opt.MapFrom(src => src.CityName))
                .ReverseMap();

            CreateMap<Pronoun, PronounDto>()
                .ReverseMap();

            CreateMap<Category, CategoryDto>()
                .ReverseMap();

            CreateMap<Preference, PreferenceDto>()
                .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.CategoryName))
                .ReverseMap();

            CreateMap<SalonReview,GetSalonReviewDto>()
                .ForMember(dest => dest.CustomerName, opt => opt.MapFrom(src => GetCustomerName(src.Customer)))
                .ReverseMap();

            CreateMap<Service, ServiceDto>()
                .ForMember(dest => dest.ServiceCategoryName, opt => opt.MapFrom(src => src.ServiceCategory.ServiceCategoryName))
                .ReverseMap();

            CreateMap<Product, ProductDto>()
                .ForMember(dest => dest.ProductBrandName, opt => opt.MapFrom(src => src.ProductBrand.ProductBrand1))
                .ForMember(dest => dest.ProductCategoryName, opt => opt.MapFrom(src => src.ProductCategory.ProductCategory1))
                .ReverseMap();

        }

        private string GetCustomerName(Customer customer)
        {
            return customer.CustomerFn + " " + customer.CustomerLn;
        }
    }

}
