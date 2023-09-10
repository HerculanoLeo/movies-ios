//
//  TestViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 10/09/23.
//

import UIKit

class AddMovieFormViewController: UIFormViewController<MovieRegisterRequest, MovieRegisterRequest.Error> {

  var delegate: AddMovieDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureForm()
  }

  func configureForm() {
    let formBuilders: [FormFieldBuilder] = [
      TextFieldBuilder(
        name: "name",
        label: "Titulo",
        defaultValue: "",
        requiered: true,
        errors: [.init(error: MovieRegisterRequest.Error.name, message: "Título é obrigatório")],
        delegate: self
      ),
      TextAreaBuilder(
        name: "synopsys",
        label: "Sinopse",
        defaultValue: nil,
        requiered: false,
        errors: [.init(error: MovieRegisterRequest.Error.synopsys, message: "Sinopse deve ter ao menos 5 letras")],
        delegate: self
      ),
      DropdownBuilder(
        name: "ageGroup",
        label: "Classificação Etaria",
        options: [
          .init(label: "Livre", value: "Livre"),
          .init(label: "12 anos", value: "12 anos"),
          .init(label: "14 anos", value: "14 anos"),
          .init(label: "18 anos", value: "18 anos"),
        ],
        selectedOption: .init(label: "Selecione uma opção", value: ""),
        defaultOption: .init(label: "Selecione uma opção", value: ""),
        requiered: true,
        errors: [.init(error: MovieRegisterRequest.Error.ageGroup, message: "Classificação Etaria é obrigatório")],
        delegate: self
      ),
      TextFieldBuilder(
        name: "movieCoverUrl",
        label: "Miniatura",
        defaultValue: nil,
        requiered: false,
        errors: [.init(error: MovieRegisterRequest.Error.movieCoverUrl, message: "Url inválida")],
        delegate: self
      ),
      TextFieldBuilder(
        name: "movieWallpaperUrl",
        label: "Wallpaper",
        defaultValue: nil,
        requiered: false,
        errors: [.init(error: MovieRegisterRequest.Error.movieWallpaperUrl, message: "Url inválida")],
        delegate: self
      ),
      RatingStarsViewBuilder(name: "stars", label: "", defaultValue: 0, requiered: true, errors: [])
    ]

    super.build(formBuilders, addMovieConstraints)

    setTitle("Novo Filme")

    super.onSubmit = { value in
      self.save(value)
    }

    super.failedSubmit = { error in
      self.showToast(message: error.message)
    }
  }

  func save(_ requestEntity: MovieRegisterRequest) {
    MovieApiResource.register(requestEntity: requestEntity) {[weak self] result in
      print(result)
      switch result {
      case .success(_):
        self?.showToast(message: "Sucesso ao salvar!")
        self?.delegate?.onMovieRegistered()
        self?.navigationController?.popViewController(animated: true)
      case .failure(let error):
        self?.showToast(message: "Falha ao salvar!")
        print(error.localizedDescription)
      }
    }
  }

}
