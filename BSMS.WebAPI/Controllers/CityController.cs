using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CitiesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CitiesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CityDto>>> Get()
        {
            var result = await _mediator.Send(new GetAllCitiesQuery());

            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CityDto>> GetById(int id)
        {
            var result = await _mediator.Send(new GetCityByIdQuery { CityId = id });

            return Ok(result);
        }
    }
}
