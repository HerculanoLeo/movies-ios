//
//  Movie.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation

struct Movie: Decodable {
  var id: String
  var name: String
  var synopsys: String?
  var ageGroup: String
  var stars: Int
  var movieCoverUrl: String?;
  var movieWallpaperUrl: String?;

  mutating func changeStars(_ stars: Int) {
    self.stars = stars
  }
}

let moviesMock: [Movie] = [
  Movie(id: "1", name: "Homem de Ferro", synopsys: "Tony Stark (Robert Downey Jr.) é um industrial bilionário, que também é um brilhante inventor. Ao ser sequestrado ele é obrigado por terroristas a construir uma arma devastadora mas, ao invés disto, constrói uma armadura de alta tecnologia que permite que fuja de seu cativeiro. A partir de então ele passa a usá-la para combater o crime, sob o alter-ego do Homem de Ferro.", ageGroup: "não recomendado para menores de 12 (doze) anos", stars: 4, movieCoverUrl: "https://br.web.img2.acsta.net/c_310_420/medias/nmedia/18/91/79/19/20163665.jpg", movieWallpaperUrl: "https://wallpapercave.com/wp/wp3519520.jpg"),
  Movie(id: "2", name: "Homem de Ferro 2", synopsys: "Após confessar ao mundo ser o Homem de Ferro, Tony Stark (Robert Downey Jr.) passa a ser alvo do governo dos Estados Unidos, que deseja que ele entregue seu poderoso traje. Com a negativa, o governo passa a desenvolver um novo traje com o maior rival de Stark, Justin Hammer (Sam Rockwell). Jim Rhodes (Don Cheadle), o braço direito de Tony, é colocado no centro deste conflito, o que faz com que assuma a identidade de Máquina de Combate. Paralelamente, Ivan Vanko (Mickey Rourke) cria o alter-ego de Whiplash para se vingar dos atos da família Stark no passado. Para combater Whiplash e a perseguição do governo, Stark conta com o apoio de sua nova assistente, Natasha Romanoff (Scarlett Johansson), e de Nick Fury (Samuel L. Jackson), o diretor da S.H.I.E.L.D.", ageGroup: "não recomendado para menores de 12 (doze) anos", stars: 4, movieCoverUrl: "https://br.web.img2.acsta.net/c_310_420/medias/nmedia/18/87/31/07/19874181.jpg", movieWallpaperUrl: "https://duastorres.com.br/wp-content/uploads/2018/01/Iron-Man-2.jpg"),
  Movie(id: "3", name: "Homem de Ferro 3", synopsys: "Desde o ataque dos chitauri a Nova York, Tony Stark (Robert Downey Jr.) vem enfrentando dificuldades para dormir e, quando consegue, tem terríveis pesadelos. Ele teme não conseguir proteger sua namorada Pepper Potts (Gwyneth Paltrow) dos vários inimigos que passou a ter após vestir a armadura do Homem de Ferro. Um deles, o Mandarim (Ben Kingsley), decide atacá-lo com força total, destruindo sua mansão e colocando a vida de Pepper em risco. Para enfrentá-lo Stark precisará ressurgir do fundo do mar, para onde foi levado junto com os destroços da mansão, e superar seu maior medo: o de fracassar.", ageGroup: "não recomendado para menores de 12 (doze) anos", stars: 3, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/medias/nmedia/18/92/08/07/20488996.jpg", movieWallpaperUrl: "https://3.bp.blogspot.com/-WTptCXGVAa8/UTc4jz3PpgI/AAAAAAAABYY/uAz3CN3-YPo/s1600/superimagem-megacurioso-570779036003440629.jpg"),
  Movie(id: "4", name: "Capitão América: O Primeiro Vingador", synopsys: "2ª Guerra Mundial. Steve Rogers (Chris Evans) é um jovem que aceitou ser voluntário em uma série de experiências que visam criar o supersoldado americano. Os militares conseguem transformá-lo em uma arma humana, mas logo percebem que o supersoldado é valioso demais para pôr em risco na luta contra os nazistas. Desta forma, Rogers é usado como uma celebridade do exército, marcando presença em paradas realizadas pela Europa no intuito de levantar a estima dos combatentes. Para tanto passa a usar uma vestimenta com as cores da bandeira dos Estados Unidos, azul, branca e vermelha. Só que um plano nazista faz com que Rogers entre em ação e assuma a alcunha de Capitão América, usando seus dons para combatê-los em plenas trincheiras da guerra.", ageGroup: "não recomendado para menores de 12 (doze) anos", stars: 5, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/medias/nmedia/18/87/34/62/19874544.jpg", movieWallpaperUrl: "https://queridojeito.com/imagem/2011/03/Frases-Capitao-America-O-Primeiro-Vingador.jpg"),
  Movie(id: "5", name: "Capitão América: Guerra Civil", synopsys: "Em Capitão América: Guerra Civil, Steve Rogers (Chris Evans) é o atual líder dos Vingadores, super-grupo de heróis formado por Viúva Negra (Scarlett Johansson), Feiticeira Escarlate (Elizabeth Olsen), Visão (Paul Bettany), Falcão (Anthony Mackie) e Máquina de Combate (Don Cheadle). O ataque de Ultron fez com que os políticos buscassem algum meio de controlar os super-heróis, já que seus atos afetam toda a humanidade. Tal decisão coloca o Capitão América em rota de colisão com Tony Stark (Robert Downey Jr.), o Homem de Ferro.", ageGroup: "Não recomendado para menores de 12 anos", stars: 5, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/pictures/16/03/10/20/36/363874.jpg", movieWallpaperUrl: "https://i1.wp.com/www.papeldeparede.etc.br/fotos/wp-content/uploads/CA29.jpg"),
  Movie(id: "6", name: "Os Vingadores", synopsys: "Loki (Tom Hiddleston) retorna à Terra enviado pelos chitauri, uma raça alienígena que pretende dominar os humanos. Com a promessa de que será o soberano do planeta, ele rouba o cubo cósmico dentro de instalações da S.H.I.E.L.D. e, com isso, adquire grandes poderes. Loki os usa para controlar o dr. Erik Selvig (Stellan Skarsgard) e Clint Barton/Gavião Arqueiro (Jeremy Renner), que passam a trabalhar para ele. No intuito de contê-los, Nick Fury (Samuel L. Jackson) convoca um grupo de pessoas com grandes habilidades, mas que jamais haviam trabalhado juntas: Tony Stark/Homem de Ferro (Robert Downey Jr.), Steve Rogers/Capitão América (Chris Evans), Thor (Chris Hemsworth), Bruce Banner/Hulk (Mark Ruffalo) e Natasha Romanoff/Viúva Negra (Scarlett Johansson). Só que, apesar do grande perigo que a Terra corre, não é tão simples assim conter o ego e os interesses de cada um deles para que possam agir em grupo.", ageGroup: "Não recomendado para menores de 12 anos", stars: 5, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/medias/nmedia/18/89/43/82/20052140.jpg", movieWallpaperUrl: "https://www.filmofilia.com/wp-content/uploads/2012/02/The_Avengers.jpg"),
  Movie(id: "7", name: "Vigadores: Era de Ultron", synopsys: "Tentanto proteger o planeta de ameaças como as vistas no primeiro Os Vingadores, Tony Stark busca construir um sistema de inteligência artifical que cuidaria da paz mundial. O projeto acaba dando errado e gera o nascimento do Ultron (voz de James Spader). Capitão América (Chris Evans), Homem de Ferro (Robert Downey Jr.), Thor (Chris Hemsworth), Hulk (Mark Ruffalo), Viúva Negra (Scarlett Johansson) e Gavião Arqueiro (Jeremy Renner) terão que se unir para mais uma vez salvar o dia.", ageGroup: "Não recomendado para menores de 12 anos", stars: 3, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/pictures/15/02/24/18/27/528824.jpg", movieWallpaperUrl: "https://duastorres.com.br/wp-content/uploads/2018/04/Age-of-Ultron.jpg"),
  Movie(id: "8", name: "Doutor Estranho no Multiverso da Loucura", synopsys: "Em Doutor Estranho no Multiverso da Loucura, após derrotar Dormammu e enfrentar Thanos nos eventos de Vingadores: Ultimato, o Mago Supremo, Stephen Strange (Benedict Cumberbatch), e seu parceiro Wong (Benedict Wong), continuam suas pesquisas sobre a Joia do Tempo. Mas um velho amigo que virou inimigo coloca um ponto final nos seus planos e faz com que Strange desencadeie um mal indescritível, o obrigando a enfrentar uma nova e poderosa ameaça. O longa se conecta com a série do Disney+ WandaVision e tem relação também com Loki. O longa pertence a fase 4 do MCU onde a realidade do universo pode entrar em colapso por causa do mesmo feitiço que trouxe os vilões do Teioso para o mundo dos Vingadores e o Mago Supremo precisará contar com a ajuda de Wanda (Elizabeth Olsen), que vive isolada desde os eventos de WandaVision.", ageGroup: "Não recomendado para menores de 14 anos", stars: 1, movieCoverUrl: "https://br.web.img3.acsta.net/c_310_420/pictures/22/02/14/18/29/1382589.png", movieWallpaperUrl: "https://image.tmdb.org/t/p/original/d0LfrKXMogbJujV6Mc7L9cUssC8.jpg")
]
